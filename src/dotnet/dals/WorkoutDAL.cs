using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("Workouts")]
    public class WorkoutDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int WorkoutID { get; set; }  // Primary Key

        [Required]
        public int UserID { get; set; }  // Foreign Key for User

        [Required]
        public int CategoryID { get; set; }  // Foreign Key for WorkoutCategory

        [Required]
        public double Distance { get; set; }

        [Required]
        public DateTime StartDate { get; set; }

        public DateTime? EndDate { get; set; }

        // Navigation Properties
        [ForeignKey("UserID")]
        public UserDAL User { get; set; }  // Relationship to UserDAL

        [ForeignKey("CategoryID")]
        public WorkoutCategoryDAL Category { get; set; }  // Relationship to WorkoutCategoryDAL

        // One-to-One Relationship with WorkoutCalories
        public WorkoutCaloriesDAL WorkoutCalories { get; set; }
    }
}