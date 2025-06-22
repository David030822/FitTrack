using dotnet.DAL;
using dotnet.Data;
using Microsoft.EntityFrameworkCore;

namespace dotnet.Repositories
{
    public class PlannedMealRepository : IPlannedMealRepository
    {
        private readonly AppDbContext _context;

        public PlannedMealRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<PlannedMealDAL?> GetByIdAsync(int id)
        {
            return await _context.PlannedMeals.FindAsync(id);
        }

        public async Task<List<PlannedMealDAL>> GetByDayIdAsync(int dayId)
        {
            return await _context.PlannedMeals
                .Where(m => m.MealScheduleDayID == dayId)
                .ToListAsync();
        }

        public async Task AddAsync(PlannedMealDAL meal)
        {
            await _context.PlannedMeals.AddAsync(meal);
        }

        public Task UpdateAsync(PlannedMealDAL meal)
        {
            _context.PlannedMeals.Update(meal);
            return Task.CompletedTask;
        }

        public Task DeleteAsync(PlannedMealDAL meal)
        {
            _context.PlannedMeals.Remove(meal);
            return Task.CompletedTask;
        }

        public async Task SaveChangesAsync()
        {
            await _context.SaveChangesAsync();
        }
    }
}