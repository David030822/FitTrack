using dotnet.DTOs;
using dotnet.Models;
using System.Threading.Tasks;

public interface IAuthService
{
    Task<bool> Register(UserDTO userDto);
    Task<string> Login(LoginDTO loginDto);
}