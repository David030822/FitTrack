using dotnet.DTOs;

namespace dotnet.Repositories
{
    public interface ICaloriesGoalsRepository
    {
        Task<List<CaloriesGoalsDTO>> GetAllAsync();
        Task<CaloriesGoalsDTO?> GetByIdAsync(int id);
        Task<CaloriesGoalsDTO> CreateAsync(CaloriesGoalsDTO dto, int userId);
        Task<bool> UpdateAsync(int id, CaloriesGoalsDTO dto);
        Task<bool> DeleteAsync(int id);
        Task<bool> UpsertAsync(int userId, CaloriesGoalsDTO dto);
        Task<double> GetDailyCaloriesBurnedAsync(int userId, DateTime today);
        Task<double> GetDailyIntakeAsync(int userId, DateTime today);
        Task<CaloriesGoalsDTO> GetStreaksAsync(int userId);
    }
}
