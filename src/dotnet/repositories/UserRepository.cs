using dotnet.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using dotnet.Repositories.Interfaces;
using dotnet.Data;
using dotnet.DAL;
using dotnet.Helper;
using Microsoft.EntityFrameworkCore;

namespace dotnet.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly AppDbContext _context;

        public UserRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<User>> GetAllUsersAsync()
        {
            List<UserDAL> data = await _context.Users.ToListAsync();
            return data.Select(UserConverter.FromUserDALToUser).ToList();
        }

        public async Task<User> GetUserByIdAsync(int id)
        {
            var userDAL = await _context.Users.FindAsync(id);
            return userDAL != null ? UserConverter.FromUserDALToUser(userDAL) : null;
        }

        public async Task CreateUserAsync(User user)
        {
            var userDAL = UserConverter.FromUserToUserDAL(user);
            _context.Users.Add(userDAL);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateUserAsync(int id, User updatedUser)
        {
            var existingUserDAL = await _context.Users.FindAsync(id);
            if (existingUserDAL == null)
                return;

            existingUserDAL.FirstName = updatedUser.FirstName;
            existingUserDAL.LastName = updatedUser.LastName;
            existingUserDAL.Email = updatedUser.Email;
            existingUserDAL.ProfilePhotoPath = updatedUser.ProfilePhotoPath;

            _context.Users.Update(existingUserDAL);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteUserAsync(int id)
        {
            var userDAL = await _context.Users.FindAsync(id);
            if (userDAL == null)
                return;

            _context.Users.Remove(userDAL);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> UserExists(string email)
        {
            return await _context.Users.AnyAsync(u => u.Email == email);
        }

        public async Task<UserDAL> GetUserByEmail(string email)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
        }
    }
}