using dotnet.DAL;

namespace dotnet.Services
{
    public interface IMealScheduleService
    {
        Task<List<MealScheduleDAL>> GetSchedulesForUserAsync(int userId);
        Task<MealScheduleDAL?> GetScheduleByIdAsync(int scheduleId);
        Task<MealScheduleDAL> CreateScheduleAsync(int userId, string title);
        Task UpdateScheduleTitleAsync(int scheduleId, string newTitle);
        Task DeleteScheduleAsync(int scheduleId);

        Task<List<PlannedMealDAL>> GetMealsForDayAsync(int dayId);
        Task<PlannedMealDAL> AddMealToDayAsync(int dayId, PlannedMealDAL meal);
        Task UpdateMealAsync(PlannedMealDAL meal);
        Task DeleteMealAsync(int mealId);
        Task SetActiveScheduleAsync(int scheduleId);
        Task ToggleCheatDayAsync(int dayId);
        Task LogMealAsync(int mealId, MealStatus status);
        Task<List<MealLog>> GetWeeklyLogsAsync(int userId);
        Task<MealScheduleDayDAL> GetDayAsync(int dayId);
    }
}