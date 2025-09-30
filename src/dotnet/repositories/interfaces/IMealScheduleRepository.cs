using dotnet.DAL;

namespace dotnet.Repositories
{
    public interface IMealScheduleRepository
    {
        Task<List<MealScheduleDAL>> GetAllByUserIdAsync(int userId);
        Task<MealScheduleDAL?> GetByIdAsync(int id);
        Task<MealScheduleDAL> CreateAsync(MealScheduleDAL schedule);
        Task UpdateScheduleTitleAsync(int scheduleId, string newTitle);
        Task DeleteAsync(MealScheduleDAL schedule);
        Task SetActiveScheduleAsync(int scheduleId);
        Task LogMealAsync(int mealId, MealStatus status);
        Task<List<MealLog>> GetWeeklyLogsAsync(int userId);
        Task SaveChangesAsync();
    }
}
