using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("MealScheduleDays")]
    public class MealScheduleDayDAL
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int MealScheduleDayID { get; set; }

        [Required]
        public int MealScheduleID { get; set; }

        [ForeignKey("MealScheduleID")]
        public MealScheduleDAL MealSchedule { get; set; }

        [Required]
        public int DayOfWeek { get; set; } // 0 = Monday, 6 = Sunday
        public bool IsCheatDay { get; set; } = false; // UI toggle disables list

        public ICollection<PlannedMealDAL> PlannedMeals { get; set; }
    }
}
