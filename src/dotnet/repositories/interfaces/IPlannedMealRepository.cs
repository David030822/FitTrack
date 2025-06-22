using dotnet.DAL;

namespace dotnet.Repositories
{
    public interface IPlannedMealRepository
    {
        Task<PlannedMealDAL?> GetByIdAsync(int id);
        Task<List<PlannedMealDAL>> GetByDayIdAsync(int dayId);
        Task AddAsync(PlannedMealDAL meal);
        Task UpdateAsync(PlannedMealDAL meal);
        Task DeleteAsync(PlannedMealDAL meal);
        Task SaveChangesAsync();
    }
}