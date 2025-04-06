using dotnet.Models;

public interface ICategoryRepository
{
    Task<IEnumerable<WorkoutCategory>> GetAllCategoriesAsync();
    Task<WorkoutCategory?> GetCategoryByIdAsync(int id);
    Task AddCategoryAsync(WorkoutCategory category);
    Task DeleteCategoryAsync(int id);
}
