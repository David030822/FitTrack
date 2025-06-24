public class WorkoutPlanRequestDTO
{
    public int UserId { get; set; }              // Who the advice is for
    public string UserInput { get; set; } = "";  // Optional question or input
    public string WorkoutType { get; set; } = "";   // Optional workout type
    public int NumberOfExercises { get; set; } = 0;  // Optional number of exercises
    public int Duration { get; set; } = 0;          // Optional duration
    public string Difficulty { get; set; } = "";     // Optional difficulty
    public string ExerciseFocus { get; set; } = "";  // Optional exercise focus
}
