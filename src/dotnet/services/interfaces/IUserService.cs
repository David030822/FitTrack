using dotnet.DAL;
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
        Task<IEnumerable<User>> SearchUsersAsync(string query);
        Task<bool> FollowUserAsync(int userId, int followingId);
        Task<bool> UnfollowUserAsync(int userId, int followingId);
        Task<bool> IsFollowingAsync(int userId, int targetUserId);
        Task<IEnumerable<User>> GetFollowingAsync(int userId);
        Task<IEnumerable<User>> GetFollowersAsync(int userId);
    }
}
