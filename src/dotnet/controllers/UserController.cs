using dotnet.Models;
using Microsoft.AspNetCore.Mvc;

namespace dotnet.Controllers;

[ApiController]
[Route("[controller]")]

public class UserController : ControllerBase{
    private static List<User> users = new List<User>();

    [HttpGet]
    // [Route("users")]
    public ActionResult<IEnumerable<User>> Get(){
        return Ok(users);
    }

    [HttpPost]
    // [Route("users")]
    public ActionResult<User> Post(User user){
        if (user == null){
            return BadRequest();
        }

        users.Add(user);
        return Ok(user);
    }

    [HttpPut]
    // [Route("users/{id}")]    
    public ActionResult<User> Put(int id, User user){
        if (user == null){
            return BadRequest();
        }

        var existingUser = users.Find(u => u.Id == id);
        if (existingUser == null){
            return NotFound();
        }

        existingUser.FirstName = user.FirstName;
        existingUser.LastName = user.LastName;
        existingUser.Email = user.Email;
        existingUser.Password = user.Password;
        existingUser.ProfilePhotoPath = user.ProfilePhotoPath;

        return Ok(existingUser);
    }

    [HttpDelete]
    // [Route("users/{id}")]    
    public ActionResult<User> Delete(int id){
        var existingUser = users.Find(u => u.Id == id);
        if (existingUser == null){
            return NotFound();
        }

        users.Remove(existingUser);
        return Ok(existingUser);
    }
}