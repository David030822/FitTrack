using dotnet.DAL;

namespace dotnet.Repositories
{
    public interface IWorkoutScheduleRepository
    {
        Task<List<WorkoutScheduleDAL>> GetSchedulesForUserAsync(int userId);
        Task<WorkoutScheduleDAL?> GetScheduleByIdAsync(int scheduleId);
        Task<WorkoutScheduleDAL> CreateScheduleAsync(WorkoutScheduleDAL schedule);
        Task UpdateScheduleTitleAsync(int scheduleId, string newTitle);
        Task DeleteScheduleAsync(int scheduleId);
        Task ToggleActiveScheduleAsync(int scheduleId);
        Task SaveChangesAsync();
    }
}