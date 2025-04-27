using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("Users")]
    public class UserDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int UserID { get; set; }  // Auto-increment primary key
        public int? UDID { get; set; }  // Unique Device Identifier

        [Required]
        [MaxLength(50)]
        public string FirstName { get; set; }

        [Required]
        [MaxLength(50)]
        public string LastName { get; set; }

        [Required]
        [EmailAddress]
        [MaxLength(100)]
        public string Email { get; set; }
        [MaxLength(15)]
        public string? PhoneNum { get; set; }

        [Required]
        [MaxLength(50)]
        public string Username { get; set; }

        [Required]
        [MaxLength(255)]  // Store hashed passwords, so we allocate enough space
        public byte[] PasswordHash { get; set; }

        [Required]
        [MaxLength(255)]
        public byte[] PasswordSalt { get; set; }

        public string? ProfilePhotoPath { get; set; }  // Optional profile photo

        public int? ParentID { get; set; }  // Optional parent ID

        // Navigation Properties - These ensure relationships are mapped in EF Core

        // One-to-Many: A user has multiple meals
        public ICollection<MealDAL> Meals { get; set; } = new List<MealDAL>();

        // One-to-Many: A user has multiple workouts
        public ICollection<WorkoutDAL> Workouts { get; set; } = new List<WorkoutDAL>();

        // One-to-Many: A user has multiple heatmaps
        public ICollection<HeatmapDAL> Heatmaps { get; set; } = new List<HeatmapDAL>();

        // One-to-Many: A user has multiple goals
        public ICollection<GoalDAL> Goals { get; set; } = new List<GoalDAL>();

        // One-to-One: A user has one calories goal
        public CaloriesGoalsDAL? CaloriesGoals { get; set; }

        // Many-to-Many: Following system
        [InverseProperty("Follower")]
        public ICollection<FollowingDAL> FollowingUsers { get; set; } = new List<FollowingDAL>();

        [InverseProperty("Followed")]
        public ICollection<FollowingDAL> Followers { get; set; } = new List<FollowingDAL>();

        // Self-referencing relationship: Parent-Child
        [ForeignKey("ParentID")]
        public UserDAL? Parent { get; set; }  
        public ICollection<UserDAL>? Children { get; set; } = new List<UserDAL>();

        // One-to-One: User -> AppDevices
        // [ForeignKey("UDID")] // Assuming UDID is the primary key in AppDevices table
        // public AppDevicesDAL? AppDevices { get; set; }
    }
}