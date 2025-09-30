using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("Calories")]
    public class CaloriesDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int CaloriesID { get; set; }
        [Required]
        public double Amount { get; set; }
        [Required]
        public DateTime DateTime { get; set; }

        // Navigation property for one-to-one relationship
        public WorkoutCaloriesDAL? WorkoutCalories { get; set; }
        public StepsDAL? Steps { get; set; }
        public MealDAL? Meal { get; set; }
    }
}