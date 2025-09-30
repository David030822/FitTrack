using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AppDevices",
                columns: table => new
                {
                    UDID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Registered = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    Used = table.Column<double>(type: "double precision", nullable: false),
                    LastUsed = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppDevices", x => x.UDID);
                });

            migrationBuilder.CreateTable(
                name: "AppLogs",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    File = table.Column<string>(type: "text", nullable: false),
                    Request = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppLogs", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Goal",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    Text = table.Column<string>(type: "text", nullable: false),
                    IsCompleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Goal", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Levels",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Color = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Levels", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "WorkoutCategories",
                columns: table => new
                {
                    CategoryID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    Icon = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WorkoutCategories", x => x.CategoryID);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    UserID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UDID = table.Column<int>(type: "integer", nullable: false),
                    FirstName = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    LastName = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Password = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    ProfilePhotoPath = table.Column<string>(type: "text", nullable: true),
                    ParentID = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.UserID);
                    table.ForeignKey(
                        name: "FK_Users_AppDevices_UDID",
                        column: x => x.UDID,
                        principalTable: "AppDevices",
                        principalColumn: "UDID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Users_Users_ParentID",
                        column: x => x.ParentID,
                        principalTable: "Users",
                        principalColumn: "UserID",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Following",
                columns: table => new
                {
                    FollowingID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    FollowerID = table.Column<int>(type: "integer", nullable: false),
                    FollowedID = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Following", x => x.FollowingID);
                    table.ForeignKey(
                        name: "FK_Following_Users_FollowedID",
                        column: x => x.FollowedID,
                        principalTable: "Users",
                        principalColumn: "UserID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Following_Users_FollowerID",
                        column: x => x.FollowerID,
                        principalTable: "Users",
                        principalColumn: "UserID",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Goals",
                columns: table => new
                {
                    GoalID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserID = table.Column<int>(type: "integer", nullable: false),
                    Text = table.Column<string>(type: "text", nullable: false),
                    IsCompleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Goals", x => x.GoalID);
                    table.ForeignKey(
                        name: "FK_Goals_Users_UserID",
                        column: x => x.UserID,
                        principalTable: "Users",
                        principalColumn: "UserID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Heatmap",
                columns: table => new
                {
                    HeatmapID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserID = table.Column<int>(type: "integer", nullable: false),
                    LevelID = table.Column<int>(type: "integer", nullable: false),
                    Date = table.Column<DateOnly>(type: "date", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Heatmap", x => x.HeatmapID);
                    table.ForeignKey(
                        name: "FK_Heatmap_Levels_LevelID",
                        column: x => x.LevelID,
                        principalTable: "Levels",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Heatmap_Users_UserID",
                        column: x => x.UserID,
                        principalTable: "Users",
                        principalColumn: "UserID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "GoalChecked",
                columns: table => new
                {
                    GoalID = table.Column<int>(type: "integer", nullable: false),
                    Date = table.Column<DateOnly>(type: "date", nullable: false),
                    GoalDALGoalID = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GoalChecked", x => x.GoalID);
                    table.ForeignKey(
                        name: "FK_GoalChecked_Goal_GoalID",
                        column: x => x.GoalID,
                        principalTable: "Goal",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_GoalChecked_Goals_GoalDALGoalID",
                        column: x => x.GoalDALGoalID,
                        principalTable: "Goals",
                        principalColumn: "GoalID");
                });

            migrationBuilder.CreateTable(
                name: "Calories",
                columns: table => new
                {
                    CaloriesID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Amount = table.Column<double>(type: "double precision", nullable: false),
                    DateTime = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    WorkoutCaloriesWorkoutID = table.Column<int>(type: "integer", nullable: false),
                    WorkoutCaloriesCaloriesID = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Calories", x => x.CaloriesID);
                });

            migrationBuilder.CreateTable(
                name: "Meals",
                columns: table => new
                {
                    MealID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserID = table.Column<int>(type: "integer", nullable: false),
                    CaloriesID = table.Column<int>(type: "integer", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Meals", x => x.MealID);
                    table.ForeignKey(
                        name: "FK_Meals_Calories_CaloriesID",
                        column: x => x.CaloriesID,
                        principalTable: "Calories",
                        principalColumn: "CaloriesID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Meals_Users_UserID",
                        column: x => x.UserID,
                        principalTable: "Users",
                        principalColumn: "UserID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Steps",
                columns: table => new
                {
                    StepsID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    StepsCount = table.Column<int>(type: "integer", nullable: false),
                    Date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    CaloriesID = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Steps", x => x.StepsID);
                    table.ForeignKey(
                        name: "FK_Steps_Calories_CaloriesID",
                        column: x => x.CaloriesID,
                        principalTable: "Calories",
                        principalColumn: "CaloriesID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "WorkoutCalories",
                columns: table => new
                {
                    WorkoutID = table.Column<int>(type: "integer", nullable: false),
                    CaloriesID = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WorkoutCalories", x => new { x.WorkoutID, x.CaloriesID });
                    table.ForeignKey(
                        name: "FK_WorkoutCalories_Calories_CaloriesID",
                        column: x => x.CaloriesID,
                        principalTable: "Calories",
                        principalColumn: "CaloriesID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Workouts",
                columns: table => new
                {
                    WorkoutID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserID = table.Column<int>(type: "integer", nullable: false),
                    CategoryID = table.Column<int>(type: "integer", nullable: false),
                    Distance = table.Column<double>(type: "double precision", nullable: false),
                    StartDate = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    EndDate = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    WorkoutCaloriesWorkoutID = table.Column<int>(type: "integer", nullable: false),
                    WorkoutCaloriesCaloriesID = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Workouts", x => x.WorkoutID);
                    table.ForeignKey(
                        name: "FK_Workouts_Users_UserID",
                        column: x => x.UserID,
                        principalTable: "Users",
                        principalColumn: "UserID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Workouts_WorkoutCalories_WorkoutCaloriesWorkoutID_WorkoutCa~",
                        columns: x => new { x.WorkoutCaloriesWorkoutID, x.WorkoutCaloriesCaloriesID },
                        principalTable: "WorkoutCalories",
                        principalColumns: new[] { "WorkoutID", "CaloriesID" },
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Workouts_WorkoutCategories_CategoryID",
                        column: x => x.CategoryID,
                        principalTable: "WorkoutCategories",
                        principalColumn: "CategoryID",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Calories_WorkoutCaloriesWorkoutID_WorkoutCaloriesCaloriesID",
                table: "Calories",
                columns: new[] { "WorkoutCaloriesWorkoutID", "WorkoutCaloriesCaloriesID" });

            migrationBuilder.CreateIndex(
                name: "IX_Following_FollowedID",
                table: "Following",
                column: "FollowedID");

            migrationBuilder.CreateIndex(
                name: "IX_Following_FollowerID",
                table: "Following",
                column: "FollowerID");

            migrationBuilder.CreateIndex(
                name: "IX_GoalChecked_GoalDALGoalID",
                table: "GoalChecked",
                column: "GoalDALGoalID");

            migrationBuilder.CreateIndex(
                name: "IX_Goals_UserID",
                table: "Goals",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_Heatmap_LevelID",
                table: "Heatmap",
                column: "LevelID");

            migrationBuilder.CreateIndex(
                name: "IX_Heatmap_UserID",
                table: "Heatmap",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_Meals_CaloriesID",
                table: "Meals",
                column: "CaloriesID",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Meals_UserID",
                table: "Meals",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_Steps_CaloriesID",
                table: "Steps",
                column: "CaloriesID",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_ParentID",
                table: "Users",
                column: "ParentID");

            migrationBuilder.CreateIndex(
                name: "IX_Users_UDID",
                table: "Users",
                column: "UDID",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_WorkoutCalories_CaloriesID",
                table: "WorkoutCalories",
                column: "CaloriesID");

            migrationBuilder.CreateIndex(
                name: "IX_Workouts_CategoryID",
                table: "Workouts",
                column: "CategoryID");

            migrationBuilder.CreateIndex(
                name: "IX_Workouts_UserID",
                table: "Workouts",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_Workouts_WorkoutCaloriesWorkoutID_WorkoutCaloriesCaloriesID",
                table: "Workouts",
                columns: new[] { "WorkoutCaloriesWorkoutID", "WorkoutCaloriesCaloriesID" });

            migrationBuilder.AddForeignKey(
                name: "FK_Calories_WorkoutCalories_WorkoutCaloriesWorkoutID_WorkoutCa~",
                table: "Calories",
                columns: new[] { "WorkoutCaloriesWorkoutID", "WorkoutCaloriesCaloriesID" },
                principalTable: "WorkoutCalories",
                principalColumns: new[] { "WorkoutID", "CaloriesID" },
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_WorkoutCalories_Workouts_WorkoutID",
                table: "WorkoutCalories",
                column: "WorkoutID",
                principalTable: "Workouts",
                principalColumn: "WorkoutID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Calories_WorkoutCalories_WorkoutCaloriesWorkoutID_WorkoutCa~",
                table: "Calories");

            migrationBuilder.DropForeignKey(
                name: "FK_Workouts_WorkoutCalories_WorkoutCaloriesWorkoutID_WorkoutCa~",
                table: "Workouts");

            migrationBuilder.DropTable(
                name: "AppLogs");

            migrationBuilder.DropTable(
                name: "Following");

            migrationBuilder.DropTable(
                name: "GoalChecked");

            migrationBuilder.DropTable(
                name: "Heatmap");

            migrationBuilder.DropTable(
                name: "Meals");

            migrationBuilder.DropTable(
                name: "Steps");

            migrationBuilder.DropTable(
                name: "Goal");

            migrationBuilder.DropTable(
                name: "Goals");

            migrationBuilder.DropTable(
                name: "Levels");

            migrationBuilder.DropTable(
                name: "WorkoutCalories");

            migrationBuilder.DropTable(
                name: "Calories");

            migrationBuilder.DropTable(
                name: "Workouts");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "WorkoutCategories");

            migrationBuilder.DropTable(
                name: "AppDevices");
        }
    }
}
