using dotnet.Models;
using dotnet.Repositories;
using System.Collections.Generic;
using System.Threading.Tasks;
using dotnet.Services.Interfaces;
using dotnet.Repositories.Interfaces;
using dotnet.DTOs;

namespace dotnet.Services
{
    public class UserService : IUserService
    {
        private readonly IUserRepository _userRepository;

        public UserService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public async Task<IEnumerable<UserDTO>> GetAllUsersAsync()
        {
            var users = await _userRepository.GetAllUsersAsync();
            return users.Select(user => new UserDTO
            {
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                PhoneNum = user.PhoneNum,   // 👈 DON'T FORGET THIS
                Username = user.Username,   // 👈 THIS TOO
                ProfilePhotoPath = user.ProfilePhotoPath  // 👈 AND THIS
            });
        }

        public async Task<UserDTO> GetUserByIdAsync(int id)
        {
            var user = await _userRepository.GetUserByIdAsync(id);
            if (user == null)
                return null;

            return new UserDTO
            {
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                PhoneNum = user.PhoneNum,   // 👈 DON'T FORGET THIS
                Username = user.Username,   // 👈 THIS TOO
                ProfilePhotoPath = user.ProfilePhotoPath  // 👈 AND THIS
            };
        }

        public async Task CreateUserAsync(User user)
        {
            await _userRepository.CreateUserAsync(user);
        }

        public async Task UpdateUserAsync(int id, User user)
        {
            await _userRepository.UpdateUserAsync(id, user);
        }

        public async Task DeleteUserAsync(int id)
        {
            await _userRepository.DeleteUserAsync(id);
        }

        public async Task<string> UploadProfileImageAsync(IFormFile file, int userId)
        {
            Console.WriteLine($"Uploading file for user {userId}. File size: {file.Length} bytes. File name: {file.FileName}");

            Console.WriteLine($"Received file: {file?.FileName ?? "null"} - Size: {file?.Length ?? 0}");
            if (file == null || file.Length == 0)
            {
                throw new ArgumentException("No file uploaded.");
            }

            var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/uploads");
            Console.WriteLine($"Uploads folder path: {uploadsFolder}");

            Directory.CreateDirectory(uploadsFolder); // Ensure directory exists

            var user = await _userRepository.GetUserByIdAsync(userId);
            if (user == null)
            {
                throw new KeyNotFoundException("User not found");
            }

            // Delete old image if it exists
            if (!string.IsNullOrEmpty(user.ProfilePhotoPath))
            {
                var oldImagePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", user.ProfilePhotoPath.TrimStart('/'));
                if (System.IO.File.Exists(oldImagePath))
                {
                    System.IO.File.Delete(oldImagePath);
                }
            }

            // Save new image
            var fileName = $"{userId}_{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
            var filePath = Path.Combine(uploadsFolder, fileName);

            try
            {
                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(stream);
                }
                Console.WriteLine($"File successfully saved at: {filePath}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error saving file: {ex.Message}");
            }

            user.ProfilePhotoPath = $"/uploads/{fileName}";
            await _userRepository.UpdateUserAsync(userId, user);

            return user.ProfilePhotoPath;
        }
    }
}
