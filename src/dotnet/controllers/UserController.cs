using dotnet.DTOs;
using dotnet.Models;
using dotnet.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using dotnet.Helper;

namespace dotnet.Controllers
{
    [ApiController]
    [Route("api/users")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;

        public UserController(IUserService userService)
        {
            _userService = userService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserDTO>>> GetAllUsers()
        {
            var users = await _userService.GetAllUsersAsync();
            return Ok(users);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<UserDTO>> GetUserById(int id)
        {
            var user = await _userService.GetUserByIdAsync(id);
            if (user == null) return NotFound();
            return Ok(user);
        }

        [HttpPost]
        public async Task<ActionResult> CreateUser(UserDTO userDTO)
        {
            var user = UserConverter.FromUserDTOToUser(userDTO);
            await _userService.CreateUserAsync(user);
            return CreatedAtAction(nameof(GetUserById), new { id = user.Id }, user);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(int id, UserDTO userDTO)
        {
            var existingUser = await _userService.GetUserByIdAsync(id);
            if (existingUser == null) return NotFound();

            var updatedUser = UserConverter.FromUserDTOToUser(userDTO, id);
            await _userService.UpdateUserAsync(id, updatedUser);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var existingUser = await _userService.GetUserByIdAsync(id);
            if (existingUser == null) return NotFound();

            await _userService.DeleteUserAsync(id);
            return NoContent();
        }
    }
}