using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class AddLastStreakUpdateDates : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "LastBurnStreakUpdate",
                table: "CaloriesGoals",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "LastIntakeStreakUpdate",
                table: "CaloriesGoals",
                type: "timestamp with time zone",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "LastBurnStreakUpdate",
                table: "CaloriesGoals");

            migrationBuilder.DropColumn(
                name: "LastIntakeStreakUpdate",
                table: "CaloriesGoals");
        }
    }
}
