using dotnet.DAL;
using dotnet.Data;
using dotnet.DTOs;
using Microsoft.EntityFrameworkCore;

namespace dotnet.Repositories
{
    public class CaloriesGoalsRepository : ICaloriesGoalsRepository
    {
        private readonly AppDbContext _context;

        public CaloriesGoalsRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<CaloriesGoalsDTO>> GetAllAsync()
        {
            return await _context.CaloriesGoals
                .Select(c => new CaloriesGoalsDTO
                {
                    CaloriesGoalsID = c.CaloriesGoalsID,
                    IntakeGoal = c.IntakeGoal ?? 0.0,
                    OverallGoal = c.OverallGoal ?? 0.0,
                    BurnGoal = c.BurnGoal ?? 0.0,
                    IntakeStreak = c.IntakeStreak ?? 0,
                    BurnStreak = c.BurnStreak ?? 0
                }).ToListAsync();
        }

        public async Task<CaloriesGoalsDTO?> GetByIdAsync(int userId)
        {
            var entity = await _context.CaloriesGoals
                .FirstOrDefaultAsync(c => c.UserID == userId);
                
            return entity == null ? null : new CaloriesGoalsDTO
            {
                CaloriesGoalsID = entity.CaloriesGoalsID,
                IntakeGoal = entity.IntakeGoal ?? 0,
                OverallGoal = entity.OverallGoal ?? 0,
                BurnGoal = entity.BurnGoal ?? 0,
                IntakeStreak = entity.IntakeStreak ?? 0,
                BurnStreak = entity.BurnStreak ?? 0
            };
        }

        public async Task<CaloriesGoalsDTO> CreateAsync(CaloriesGoalsDTO dto, int userId)
        {
            var entity = new CaloriesGoalsDAL
            {
                IntakeGoal = dto.IntakeGoal,
                BurnGoal = dto.BurnGoal,
                OverallGoal = dto.OverallGoal,
                IntakeStreak = dto.IntakeStreak,
                BurnStreak = dto.BurnStreak,
                UserID = userId
            };

            _context.CaloriesGoals.Add(entity);
            await _context.SaveChangesAsync();

            dto.CaloriesGoalsID = entity.CaloriesGoalsID;
            return dto;
        }

        public async Task<bool> UpdateAsync(int userId, CaloriesGoalsDTO dto)
        {
            var entity = await _context.CaloriesGoals
                .FirstOrDefaultAsync(c => c.UserID == userId);

            if (entity == null) return false;

            entity.IntakeGoal = dto.IntakeGoal;
            entity.BurnGoal = dto.BurnGoal;
            entity.OverallGoal = dto.OverallGoal;
            entity.IntakeStreak = dto.IntakeStreak;
            entity.BurnStreak = dto.BurnStreak;

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var entity = await _context.CaloriesGoals.FindAsync(id);
            if (entity == null) return false;

            _context.CaloriesGoals.Remove(entity);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpsertAsync(int userId, CaloriesGoalsDTO dto)
        {
            var entity = await _context.CaloriesGoals
                .FirstOrDefaultAsync(g => g.UserID == userId);

            if (entity == null)
            {
                entity = new CaloriesGoalsDAL
                {
                    UserID = userId,
                    IntakeGoal = dto.IntakeGoal,
                    BurnGoal = dto.BurnGoal,
                    OverallGoal = dto.OverallGoal,
                    IntakeStreak = dto.IntakeStreak,
                    BurnStreak = dto.BurnStreak
                };

                _context.CaloriesGoals.Add(entity);
            }
            else
            {
                // Only update if the values are not null
                if (dto.IntakeGoal.HasValue)
                    entity.IntakeGoal = dto.IntakeGoal;

                if (dto.BurnGoal.HasValue)
                    entity.BurnGoal = dto.BurnGoal;

                if (dto.OverallGoal.HasValue)
                    entity.OverallGoal = dto.OverallGoal;

                if (dto.IntakeStreak.HasValue)
                    entity.IntakeStreak = dto.IntakeStreak;

                if (dto.BurnStreak.HasValue)
                    entity.BurnStreak = dto.BurnStreak;
            }

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<double> GetDailyCaloriesBurnedAsync(int userId, DateTime day)
        {
            var startOfDay = day.Date;
            var endOfDay = startOfDay.AddDays(1);

            var totalBurned = await _context.Workouts
                .Where(w => w.UserID == userId &&
                            w.EndDate >= startOfDay &&
                            w.EndDate < endOfDay)
                .SumAsync(w => (double?)w.WorkoutCalories.Calories.Amount) ?? 0;

            return totalBurned;
        }

        public async Task<double> GetDailyIntakeAsync(int userId, DateTime day)
        {
            var startOfDay = day.Date;
            var endOfDay = startOfDay.AddDays(1);

            var totalIntake = await _context.Meal
                .Where(m => m.UserID == userId && 
                            m.Calories.DateTime >= startOfDay && 
                            m.Calories.DateTime < endOfDay)
                .SumAsync(m => (double?)m.Calories.Amount) ?? 0.0;

            return totalIntake;
        }

        public async Task<CaloriesGoalsDTO> GetStreaksAsync(int userId)
        {
            var todayUtc = DateTime.UtcNow.Date;

            var userGoals = await _context.CaloriesGoals
                .FirstOrDefaultAsync(g => g.UserID == userId);

            if (userGoals == null)
                return null;

            var totalIntake = await GetDailyIntakeAsync(userId, todayUtc);
            var totalBurn = await GetDailyCaloriesBurnedAsync(userId, todayUtc);

            bool intakeGoalMet = userGoals.IntakeGoal.HasValue && totalIntake >= userGoals.IntakeGoal.Value;
            bool burnGoalMet = userGoals.BurnGoal.HasValue && totalBurn >= userGoals.BurnGoal.Value;

            // Update streaks ONLY if not already updated today
            if (intakeGoalMet)
            {
                if (userGoals.LastIntakeStreakUpdate == null || userGoals.LastIntakeStreakUpdate.Value.Date < todayUtc)
                {
                    userGoals.IntakeStreak = (userGoals.IntakeStreak ?? 0) + 1;
                    userGoals.LastIntakeStreakUpdate = todayUtc;
                }
            }
            else
            {
                userGoals.IntakeStreak = 0;
                userGoals.LastIntakeStreakUpdate = null; // Optional reset
            }

            if (burnGoalMet)
            {
                if (userGoals.LastBurnStreakUpdate == null || userGoals.LastBurnStreakUpdate.Value.Date < todayUtc)
                {
                    userGoals.BurnStreak = (userGoals.BurnStreak ?? 0) + 1;
                    userGoals.LastBurnStreakUpdate = todayUtc;
                }
            }
            else
            {
                userGoals.BurnStreak = 0;
                userGoals.LastBurnStreakUpdate = null; // Optional reset
            }

            await _context.SaveChangesAsync();

            var dto = new CaloriesGoalsDTO
            {
                CaloriesGoalsID = userGoals.CaloriesGoalsID,
                IntakeGoal = userGoals.IntakeGoal,
                BurnGoal = userGoals.BurnGoal,
                OverallGoal = userGoals.OverallGoal,
                IntakeStreak = userGoals.IntakeStreak,
                BurnStreak = userGoals.BurnStreak
            };

            return dto;
        }
    }
}