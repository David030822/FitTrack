using dotnet.DTOs;
using dotnet.Models;
using dotnet.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using dotnet.Helper;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace dotnet.Controllers
{
    [ApiController]
    [Route("api/users")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;
        private readonly IAuthService _authService;

        public UserController(IUserService userService, IAuthService authService)
        {
            _userService = userService;
            _authService = authService;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] UserDTO userDTO)
        {
            bool userCreated = await _authService.Register(userDTO);

            if (!userCreated)
                return BadRequest(new { message = "User already exists" });

            return Created("", new { message = "Registration successful" });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDTO loginDto)
        {
            string token = await _authService.Login(loginDto);

            if (string.IsNullOrEmpty(token))
                return Unauthorized(new { message = "Invalid email or password" });

            return Ok(new { token });
        }

        [Authorize]
        [HttpGet("user-profile")]
        public async Task<IActionResult> GetUserProfile()
        {
            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value);
            
            var user = await _userService.GetUserByIdAsync(userId);
            if (user == null) return NotFound("User not found");

            return Ok(new 
            {
                user.FirstName,
                user.LastName,
                user.Email,
                user.Username,
                user.PhoneNum,
                user.ProfilePhotoPath
            });
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

        // [Authorize]
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(int id, [FromBody] UserUpdateDTO updateDto)
        {
            var user = await _userService.GetUserByIdAsync(id);
            if (user == null) return NotFound();

            user.FirstName = updateDto.FirstName ?? user.FirstName;
            user.LastName = updateDto.LastName ?? user.LastName;
            user.Username = updateDto.Username ?? user.Username;
            user.PhoneNum = updateDto.PhoneNum ?? user.PhoneNum;
            user.ProfilePhotoPath = updateDto.ProfileImagePath ?? user.ProfilePhotoPath;

            await _userService.UpdateUserAsync(id, UserConverter.FromUserDTOToUser(user));
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

        // [Authorize]
        [HttpPost("upload-profile-image")]
        public async Task<IActionResult> UploadProfileImage(IFormFile file, [FromQuery] int userId)
        {
            try
            {
                var imageUrl = await _userService.UploadProfileImageAsync(file, userId);
                return Ok(new { imageUrl });
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
            catch (Exception)
            {
                return StatusCode(500, "An error occurred while uploading the image.");
            }
        }

        // [Authorize]
        [HttpGet("search_users")]
        public async Task<IActionResult> SearchUsers([FromQuery] string query)
        {
            var users = await _userService.SearchUsersAsync(query);
            return Ok(users);
        }

        // [Authorize]
        [HttpPost("{userId}/following/{followingId}")]
        public async Task<IActionResult> FollowUser(int userId, int followingId)
        {
            var result = await _userService.FollowUserAsync(userId, followingId);
            return result ? Ok() : BadRequest("Unable to follow user.");
        }

        // [Authorize]
        [HttpDelete("{userId}/following/{followingId}")]
        public async Task<IActionResult> UnfollowUser(int userId, int followingId)
        {
            var result = await _userService.UnfollowUserAsync(userId, followingId);
            return result ? Ok() : BadRequest("Unable to unfollow user.");
        }

        // [Authorize]
        [HttpGet("following/{userId}/{targetUserId}")]
        public async Task<IActionResult> IsFollowing(int userId, int targetUserId)
        {
            var result = await _userService.IsFollowingAsync(userId, targetUserId);
            return Ok(result);
        }

        // [Authorize]
        [HttpGet("{userId}/following")]
        public async Task<IActionResult> GetFollowing(int userId)
        {
            var following = await _userService.GetFollowingAsync(userId);
            return Ok(following);
        }

        [HttpGet("{userId}/followers")]
        public async Task<IActionResult> GetFollowers(int userId)
        {
            var followers = await _userService.GetFollowersAsync(userId);
            if (followers == null)
            {
                return NotFound("User not found or has no followers.");
            }
            return Ok(followers);
        }
    }
}