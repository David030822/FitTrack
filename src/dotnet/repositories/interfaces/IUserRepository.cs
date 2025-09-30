using dotnet.DAL;
using dotnet.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace dotnet.Repositories.Interfaces
{
    public interface IUserRepository
    {
        Task<IEnumerable<User>> GetAllUsersAsync();
        Task<User> GetUserByIdAsync(int id);
        Task CreateUserAsync(User user);
        Task UpdateUserAsync(int id, User user);
        Task DeleteUserAsync(int id);
        Task<bool> UserExists(string email);
        Task<UserDAL> GetUserByEmail(string email);
        Task<IEnumerable<User>> SearchUsersAsync(string query);
        Task<bool> AddFollowingAsync(int userId, int followingId);
        Task<bool> RemoveFollowingAsync(int userId, int followingId);
        Task<bool> IsFollowingAsync(int userId, int targetUserId);
        Task<IEnumerable<User>> GetFollowingAsync(int userId);
        public Task<IEnumerable<User>> GetFollowersAsync(int userId);
    }
}
