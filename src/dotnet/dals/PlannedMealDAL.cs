using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("PlannedMeals")]
    public class PlannedMealDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int PlannedMealID { get; set; }

        [Required]
        public int MealScheduleDayID { get; set; }

        [ForeignKey("MealScheduleDayID")]
        public MealScheduleDayDAL MealScheduleDay { get; set; }

        [Required]
        public string MealType { get; set; } // e.g., Breakfast, Lunch...

        [Required]
        public TimeOnly Time { get; set; }

        [Required]
        public string Name { get; set; }

        public string? Description { get; set; }

        public int? Calories { get; set; }
    }
}
