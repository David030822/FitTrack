namespace dotnet.Models;

public class User
{
    public int Id { get; set; }
    public int Udid { get; set; }           // Unique Device Identifier
    public AppDevices Devices { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Email { get; set; }
    public string Password { get; set; }
    public string ?ProfilePhotoPath { get; set; }
    public ICollection<Meal> Meals { get; set; } // One-to-Many: A user has multiple meals
    public ICollection<Workout> Workouts { get; set; } // One-to-Many: A user has multiple workouts
    public ICollection<Heatmap> Heatmaps { get; set; } // One-to-Many: A user has multiple heatmaps
    public ICollection<Goal> Goals { get; set; } // One-to-Many: A user has multiple goals

    // One-to-Many: A user can follow multiple users
    public ICollection<Following> FollowingUsers { get; set; } = new List<Following>(); 
    // One-to-Many: A user can be followed by multiple users
    public ICollection<Following> Followers { get; set; } = new List<Following>();

    // Self-referencing relationship: Parent-Child
    public int? ParentId { get; set; } // Nullable: Not all users have parents
    public User? Parent { get; set; }  // Navigation property
    public ICollection<User>? Children { get; set; } = new List<User>(); // Collection of child users
}