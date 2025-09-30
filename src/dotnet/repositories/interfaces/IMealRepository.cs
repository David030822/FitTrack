using dotnet.DAL;
using dotnet.DTOs;
using dotnet.Models;

namespace dotnet.Repositories
{
    public interface IMealRepository
    {
        Task<List<MealDAL>> GetAllMealsAsync();
        Task<MealDAL?> GetMealByIdAsync(int id);
        Task<Meal> AddMealAsync(Meal meal);
        Task UpdateMealAsync(Meal meal);
        Task DeleteMealAsync(int id);
        Task<IEnumerable<MealDTO>> GetMealDTOsForUserAsync(int userId);
    }
}