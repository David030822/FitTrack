using dotnet.DAL;

namespace dotnet.Repositories
{
    public interface IWorkoutScheduleDayRepository
    {
        Task<List<WorkoutScheduleDayDAL>> GetDaysForScheduleAsync(int scheduleId);
        Task<WorkoutScheduleDayDAL?> GetDayAsync(int dayId);
        Task UpdateDayAsync(WorkoutScheduleDayDAL updatedDay);
        Task ToggleRestDayAsync(int dayId);
        Task SaveChangesAsync();
    }
}