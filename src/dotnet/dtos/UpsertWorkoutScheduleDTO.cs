public class CreateWorkoutScheduleDto
{
    public string Title { get; set; }
}

public class UpdateWorkoutScheduleDto
{
    public int WorkoutScheduleID { get; set; }
    public string NewTitle { get; set; }
}

public class UpdateWorkoutDayDto
{
    public string? WorkoutLabel { get; set; }
    public TimeOnly? StartTime { get; set; }
}

public class UpsertPlannedWorkoutDto
{
    public string Name { get; set; }
    public string? Description { get; set; }
    public string TargetMuscle { get; set; }
    public int Sets { get; set; }
    public int Reps { get; set; }
    public int WorkoutScheduleDayID { get; set; }
}