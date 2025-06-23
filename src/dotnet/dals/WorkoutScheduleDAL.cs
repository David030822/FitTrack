using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("WorkoutSchedules")]
    public class WorkoutScheduleDAL
    {
        [Key]
        public int WorkoutScheduleID { get; set; }

        [Required]
        public int UserID { get; set; }

        [ForeignKey("UserID")]
        public UserDAL User { get; set; }

        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public bool IsActive { get; set; } = false;

        public string? Title { get; set; }

        public List<WorkoutScheduleDayDAL>? Days { get; set; }
    }
}