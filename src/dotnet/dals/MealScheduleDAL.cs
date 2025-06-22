using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("MealSchedules")]
    public class MealScheduleDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int MealScheduleID { get; set; }

        [Required]
        public int UserID { get; set; }

        [ForeignKey("UserID")]
        public UserDAL User { get; set; }

        public String? Title { get; set; }

        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsActive { get; set; } = false; // Only one active per user

        public ICollection<MealScheduleDayDAL> Days { get; set; }
    }
}