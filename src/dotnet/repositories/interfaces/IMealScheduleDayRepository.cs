using dotnet.DAL;

namespace dotnet.Repositories
{
    public interface IMealScheduleDayRepository
    {
        Task<MealScheduleDayDAL?> GetByIdAsync(int id);
        Task<List<MealScheduleDayDAL>> GetByScheduleIdAsync(int scheduleId);
        Task AddAsync(MealScheduleDayDAL day);
        Task ToggleCheatDayAsync(int dayId);
        Task SaveChangesAsync();
        Task<MealScheduleDayDAL> GetDayAsync(int dayId);
    }
}