using dotnet.Models;

public interface ICategoryService
{
    Task<IEnumerable<WorkoutCategory>> GetAllCategoriesAsync();
    Task<WorkoutCategory?> GetCategoryByIdAsync(int id);
    Task AddCategoryAsync(WorkoutCategory category);
    Task DeleteCategoryAsync(int id);
}
