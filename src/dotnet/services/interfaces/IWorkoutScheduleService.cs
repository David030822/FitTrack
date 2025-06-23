using dotnet.DAL;

namespace dotnet.Services
{
    public interface IWorkoutScheduleService
    {
        Task<List<WorkoutScheduleDAL>> GetSchedulesForUserAsync(int userId);
        Task<WorkoutScheduleDAL> GetScheduleByIdAsync(int id);
        Task<WorkoutScheduleDAL> CreateScheduleAsync(int userId, string title);
        Task UpdateScheduleTitleAsync(int id, string newTitle);
        Task DeleteScheduleAsync(int id);
        Task ToggleActiveScheduleAsync(int scheduleId);

        Task<List<PlannedWorkoutDAL>> GetWorkoutsForDayAsync(int dayId);
        Task<WorkoutScheduleDayDAL> GetDayAsync(int dayId);
        Task ToggleRestDayAsync(int dayId);
        Task UpdateDayAsync(int dayId, string? workoutLabel, TimeOnly? startTime);

        Task<PlannedWorkoutDAL> AddWorkoutToDayAsync(int dayId, PlannedWorkoutDAL workout);
        Task<PlannedWorkoutDAL> GetWorkoutByIdAsync(int id);
        Task UpdateWorkoutAsync(PlannedWorkoutDAL workout);
        Task DeleteWorkoutAsync(int workoutId);
    }
}