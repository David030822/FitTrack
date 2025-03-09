using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("WorkoutCalories")]
    public class WorkoutCaloriesDAL
    {
        [Required]
        public int WorkoutID { get; set; }
        public WorkoutDAL Workout { get; set; }
        [Required]
        public int CaloriesID { get; set; }
        public CaloriesDAL Calories { get; set; }
    }
}