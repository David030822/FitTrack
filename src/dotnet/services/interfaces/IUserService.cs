using dotnet.DTOs;
using dotnet.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace dotnet.Services.Interfaces
{
    public interface IUserService
    {
        Task<IEnumerable<UserDTO>> GetAllUsersAsync();
        Task<UserDTO> GetUserByIdAsync(int id);
        Task CreateUserAsync(User user);
        Task UpdateUserAsync(int id, User user);
        Task DeleteUserAsync(int id);
        public Task<string> UploadProfileImageAsync(IFormFile file, int userId);
    }
}
