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
    }
}
