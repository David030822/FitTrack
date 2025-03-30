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
            existingUserDAL.Username = updatedUser.Username;
            existingUserDAL.Email = updatedUser.Email;
            existingUserDAL.PhoneNum = updatedUser.PhoneNum;
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

        public async Task<IEnumerable<User>> SearchUsersAsync(string query)
        {
            List<UserDAL> data = await _context.Users
                .Where(u => u.Username.Contains(query) || u.FirstName.Contains(query) || u.LastName.Contains(query))
                .ToListAsync();

            return data.Select(UserConverter.FromUserDALToUser).ToList();
        }

        public async Task<bool> AddFollowingAsync(int userId, int followingId)
        {
            var user = await _context.Users.FindAsync(userId);
            var followee = await _context.Users.FindAsync(followingId);

            if (user == null || followee == null) return false;

            var existingFollow = await _context.Followings
                .AnyAsync(f => f.FollowerID == userId && f.FollowedID == followingId);

            if (existingFollow) return false;

            _context.Followings.Add(new FollowingDAL
            {
                FollowerID = userId,
                FollowedID = followingId
            });

            return await _context.SaveChangesAsync() > 0;
        }

        public async Task<bool> RemoveFollowingAsync(int userId, int followingId)
        {
            var followRelation = await _context.Followings
                .FirstOrDefaultAsync(f => f.FollowerID == userId && f.FollowedID == followingId);

            if (followRelation == null) return false;

            _context.Followings.Remove(followRelation);
            return await _context.SaveChangesAsync() > 0;
        }

        public async Task<bool> IsFollowingAsync(int userId, int targetUserId)
        {
            return await _context.Followings
                .AnyAsync(f => f.FollowerID == userId && f.FollowedID == targetUserId);
        }

        public async Task<IEnumerable<User>> GetFollowingAsync(int userId)
        {
            List<UserDAL> data = await _context.Followings
                .Where(f => f.FollowerID == userId)
                .Select(f => f.Followed)
                .ToListAsync();

            return data.Select(UserConverter.FromUserDALToUser).ToList();
        }

        public async Task<IEnumerable<User>> GetFollowersAsync(int userId)
        {
            Console.WriteLine($"Fetching followers for user ID: {userId}");

            var query = _context.Followings.Where(f => f.FollowedID == userId);
            Console.WriteLine($"SQL Query: {query.ToQueryString()}");  // Log generated SQL (for EF Core 5+)

            List<UserDAL> data = await query.Select(f => f.Follower).ToListAsync();

            Console.WriteLine($"Followers count: {data.Count}");

            return data.Select(UserConverter.FromUserDALToUser).ToList();
        }
    }
}