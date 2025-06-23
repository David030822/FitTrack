using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace dotnet.DAL
{
    [Table("WorkoutScheduleDays")]
    public class WorkoutScheduleDayDAL
    {
        [Key]
        public int WorkoutScheduleDayID { get; set; }

        [Required]
        public int WorkoutScheduleID { get; set; }

        [ForeignKey("WorkoutScheduleID")]
        public WorkoutScheduleDAL WorkoutSchedule { get; set; }

        [Required]
        public int DayOfWeek { get; set; } // 0 = Monday

        public bool IsRestDay { get; set; } = false;

        public TimeOnly? StartTime { get; set; }

        public string? WorkoutLabel { get; set; }

        public List<PlannedWorkoutDAL>? PlannedWorkouts { get; set; }
    }
}