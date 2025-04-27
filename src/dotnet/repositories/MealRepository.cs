// MealRepository.cs
using dotnet.Converters;
using dotnet.DAL;
using dotnet.Data;
using dotnet.DTOs;
using dotnet.Models;
using Microsoft.EntityFrameworkCore;

namespace dotnet.Repositories
{
    public class MealRepository : IMealRepository
    {
        private readonly AppDbContext _context;

        public MealRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<MealDAL>> GetAllMealsAsync()
        {
            return await _context.Meal.Include(m => m.Calories).ToListAsync();
        }

        public async Task<MealDAL?> GetMealByIdAsync(int id)
        {
            return await _context.Meal.Include(m => m.Calories).FirstOrDefaultAsync(m => m.MealID == id);
        }

        public async Task<Meal> AddMealAsync(Meal meal)
        {
            // Check if user exists
            var userExists = await _context.Users.AnyAsync(u => u.UserID == meal.UserId);
            if (!userExists)
            {
                throw new Exception($"User with ID {meal.UserId} does not exist.");
            }

            // Add calories entry first
            var caloriesDAL = new CaloriesDAL
            { 
                Amount = meal.Calories,
                DateTime = DateTime.UtcNow
            };
            _context.Calories.Add(caloriesDAL);
            await _context.SaveChangesAsync(); // Save to get CaloriesID

            // Now insert Meal
            var mealDAL = MealConverter.ToDAL(meal, caloriesDAL.CaloriesID);
            _context.Meal.Add(mealDAL);
            await _context.SaveChangesAsync();
            Console.WriteLine("DAL ID:" + mealDAL.MealID);

            var createdMeal = GetMealByIdAsync(mealDAL.MealID).Result;
            var returnedMeal = MealConverter.ToModel(createdMeal);
            Console.WriteLine("Returned Meal ID: " + returnedMeal.Id);
            return returnedMeal;
        }

        public async Task UpdateMealAsync(Meal meal)
        {
            var existingMeal = await GetMealByIdAsync(meal.Id);
            if (existingMeal == null) return;

            existingMeal.Name = meal.Name;
            existingMeal.Description = meal.Description;
            existingMeal.Calories.Amount = meal.Calories;
            
            await _context.SaveChangesAsync();
        }

        public async Task DeleteMealAsync(int id)
        {
            var meal = await GetMealByIdAsync(id);
            if (meal != null)
            {
                var calories = await _context.Calories.FindAsync(meal.CaloriesID);
                if (calories != null)
                    _context.Calories.Remove(calories);
                _context.Meal.Remove(meal);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<MealDTO>> GetMealDTOsForUserAsync(int userId)
        {
            var meals = await _context.Meal
                .Include(m => m.Calories)
                .Where(m => m.UserID == userId)
                .ToListAsync();

            foreach (var m in meals)
            {
                Console.WriteLine($"👉Repo MealID: {m.MealID}, Calories: {(m.Calories == null ? "NULL" : m.Calories.Amount.ToString())}, Date: {m.Calories.DateTime}");
            }

            return meals.Select(m => new MealDTO
            {
                Id = m.MealID,
                Name = m.Name,
                Description = m.Description,
                Calories = m.Calories.Amount,
                Date = m.Calories.DateTime.ToLocalTime() // 👈 this bad boy was missing
            }).ToList();
        }
    }
}