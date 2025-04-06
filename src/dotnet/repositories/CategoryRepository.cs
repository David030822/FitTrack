using dotnet.Data;
using dotnet.Models;
using Microsoft.EntityFrameworkCore;

public class CategoryRepository : ICategoryRepository
{
    private readonly AppDbContext _context;

    public CategoryRepository(AppDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<WorkoutCategory>> GetAllCategoriesAsync()
    {
        var categories = await _context.WorkoutCategories.ToListAsync();
        return categories.Select(CategoryConverter.FromCategoryDAL);
    }

    public async Task<WorkoutCategory?> GetCategoryByIdAsync(int id)
    {
        return CategoryConverter.FromCategoryDAL(await _context.WorkoutCategories.FindAsync(id));
    }

    public async Task AddCategoryAsync(WorkoutCategory category)
    {
        _context.WorkoutCategories.Add(CategoryConverter.ToCategoryDAL(category));
        await _context.SaveChangesAsync();
    }

    public async Task DeleteCategoryAsync(int id)
    {
        var category = await _context.WorkoutCategories.FindAsync(id);
        if (category != null)
        {
            _context.WorkoutCategories.Remove(category);
            await _context.SaveChangesAsync();
        }
    }
}
