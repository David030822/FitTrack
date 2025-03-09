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
                Email = user.Email
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
                Email = user.Email
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
    }
}
