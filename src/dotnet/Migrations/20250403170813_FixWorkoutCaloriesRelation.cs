using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class FixWorkoutCaloriesRelation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Calories_WorkoutCalories_WorkoutCaloriesWorkoutID_WorkoutCa~",
                table: "Calories");

            migrationBuilder.DropForeignKey(
                name: "FK_Workouts_WorkoutCalories_WorkoutCaloriesWorkoutID_WorkoutCa~",
                table: "Workouts");

            migrationBuilder.DropIndex(
                name: "IX_Workouts_WorkoutCaloriesWorkoutID_WorkoutCaloriesCaloriesID",
                table: "Workouts");

            migrationBuilder.DropPrimaryKey(
                name: "PK_WorkoutCalories",
                table: "WorkoutCalories");

            migrationBuilder.DropIndex(
                name: "IX_WorkoutCalories_CaloriesID",
                table: "WorkoutCalories");

            migrationBuilder.DropIndex(
                name: "IX_Calories_WorkoutCaloriesWorkoutID_WorkoutCaloriesCaloriesID",
                table: "Calories");

            migrationBuilder.DropColumn(
                name: "WorkoutCaloriesCaloriesID",
                table: "Workouts");

            migrationBuilder.DropColumn(
                name: "WorkoutCaloriesWorkoutID",
                table: "Workouts");

            migrationBuilder.DropColumn(
                name: "WorkoutCaloriesCaloriesID",
                table: "Calories");

            migrationBuilder.AddPrimaryKey(
                name: "PK_WorkoutCalories",
                table: "WorkoutCalories",
                column: "WorkoutID");

            migrationBuilder.CreateIndex(
                name: "IX_WorkoutCalories_CaloriesID",
                table: "WorkoutCalories",
                column: "CaloriesID",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Calories_WorkoutCaloriesWorkoutID",
                table: "Calories",
                column: "WorkoutCaloriesWorkoutID");

            migrationBuilder.AddForeignKey(
                name: "FK_Calories_WorkoutCalories_WorkoutCaloriesWorkoutID",
                table: "Calories",
                column: "WorkoutCaloriesWorkoutID",
                principalTable: "WorkoutCalories",
                principalColumn: "WorkoutID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Calories_WorkoutCalories_WorkoutCaloriesWorkoutID",
                table: "Calories");

            migrationBuilder.DropPrimaryKey(
                name: "PK_WorkoutCalories",
                table: "WorkoutCalories");

            migrationBuilder.DropIndex(
                name: "IX_WorkoutCalories_CaloriesID",
                table: "WorkoutCalories");

            migrationBuilder.DropIndex(
                name: "IX_Calories_WorkoutCaloriesWorkoutID",
                table: "Calories");

            migrationBuilder.AddColumn<int>(
                name: "WorkoutCaloriesCaloriesID",
                table: "Workouts",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "WorkoutCaloriesWorkoutID",
                table: "Workouts",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "WorkoutCaloriesCaloriesID",
                table: "Calories",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddPrimaryKey(
                name: "PK_WorkoutCalories",
                table: "WorkoutCalories",
                columns: new[] { "WorkoutID", "CaloriesID" });

            migrationBuilder.CreateIndex(
                name: "IX_Workouts_WorkoutCaloriesWorkoutID_WorkoutCaloriesCaloriesID",
                table: "Workouts",
                columns: new[] { "WorkoutCaloriesWorkoutID", "WorkoutCaloriesCaloriesID" });

            migrationBuilder.CreateIndex(
                name: "IX_WorkoutCalories_CaloriesID",
                table: "WorkoutCalories",
                column: "CaloriesID");

            migrationBuilder.CreateIndex(
                name: "IX_Calories_WorkoutCaloriesWorkoutID_WorkoutCaloriesCaloriesID",
                table: "Calories",
                columns: new[] { "WorkoutCaloriesWorkoutID", "WorkoutCaloriesCaloriesID" });

            migrationBuilder.AddForeignKey(
                name: "FK_Calories_WorkoutCalories_WorkoutCaloriesWorkoutID_WorkoutCa~",
                table: "Calories",
                columns: new[] { "WorkoutCaloriesWorkoutID", "WorkoutCaloriesCaloriesID" },
                principalTable: "WorkoutCalories",
                principalColumns: new[] { "WorkoutID", "CaloriesID" },
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Workouts_WorkoutCalories_WorkoutCaloriesWorkoutID_WorkoutCa~",
                table: "Workouts",
                columns: new[] { "WorkoutCaloriesWorkoutID", "WorkoutCaloriesCaloriesID" },
                principalTable: "WorkoutCalories",
                principalColumns: new[] { "WorkoutID", "CaloriesID" },
                onDelete: ReferentialAction.Cascade);
        }
    }
}
