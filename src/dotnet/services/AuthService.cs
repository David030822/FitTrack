using System.IdentityModel.Tokens.Jwt;
using System.Security.Cryptography;
using System.Text;
using dotnet.DAL;
using dotnet.DTOs;
using dotnet.Helper;
using dotnet.Repositories.Interfaces;
using dotnet.Services.Interfaces;
using Microsoft.IdentityModel.Tokens;

public class AuthService : IAuthService
{
    private readonly IUserRepository _userRepository; 
    private readonly IConfiguration _configuration;

    public AuthService(IUserRepository userRepository, IConfiguration configuration)
    {
        _userRepository = userRepository;
        _configuration = configuration;

    }

    public async Task<bool> Register(UserDTO userDto)
    {
        if (await _userRepository.UserExists(userDto.Email))
            return false;  // User already exists

        // Hash password
        CreatePasswordHash(userDto.Password, out byte[] passwordHash, out byte[] passwordSalt);

        // Convert DTO to DAL object
        var user = new UserDAL
        {
            FirstName = userDto.FirstName,
            LastName = userDto.LastName,
            Email = userDto.Email,
            PhoneNum = userDto.PhoneNum ?? "Not set",
            Username = userDto.Username,
            PasswordHash = passwordHash,
            PasswordSalt = passwordSalt
        };

        await _userRepository.CreateUserAsync(UserConverter.FromUserDALToUser(user));
        return true;
    }

    public async Task<string> Login(LoginDTO loginDto)
    {
        var user = await _userRepository.GetUserByEmail(loginDto.Email);
        if (user == null || !VerifyPasswordHash(loginDto.Password, user.PasswordHash, user.PasswordSalt))
            return null; // Invalid login

        return GenerateJwtToken(user);
    }

    private void CreatePasswordHash(string password, out byte[] passwordHash, out byte[] passwordSalt)
    {
        using (var hmac = new HMACSHA512())
        {
            passwordSalt = hmac.Key;
            passwordHash = hmac.ComputeHash(Encoding.UTF8.GetBytes(password));
        }
    }

    private bool VerifyPasswordHash(string password, byte[] storedHash, byte[] storedSalt)
    {
        using (var hmac = new HMACSHA512(storedSalt))
        {
            byte[] computedHash = hmac.ComputeHash(Encoding.UTF8.GetBytes(password));
            return storedHash.SequenceEqual(computedHash);
        }
    }

    private string GenerateJwtToken(UserDAL user)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        
        // Read the JWT key from appsettings.json
        var secretKey = _configuration["Jwt:Key"] 
            ?? throw new InvalidOperationException("JWT Secret Key is missing from configuration.");

        Console.WriteLine($"JWT Key from config: {_configuration["Jwt:Key"]}");
        
        var key = Encoding.ASCII.GetBytes(secretKey);

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new System.Security.Claims.ClaimsIdentity(new[]
            {
                new System.Security.Claims.Claim("id", user.UserID.ToString()),
                new System.Security.Claims.Claim("email", user.Email)   
            }),
            Expires = DateTime.UtcNow.AddDays(7),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}