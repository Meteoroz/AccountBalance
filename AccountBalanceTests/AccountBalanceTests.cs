using BusinessServicesLayer;
using Data;
using Microsoft.EntityFrameworkCore;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using Xunit;

namespace AccountBalanceTests
{
    public class AccountBalanceTests
    {
        private Mock<IAccountBalanceContext> dbMockContext;

        public AccountBalanceTests()
        {
            SetupMockContext();
        }

        private void SetupMockContext()
        {
            var data = GetTestAccount();
            var mockSet = new Mock<DbSet<Account>>();

            mockSet.As<IQueryable<Account>>().Setup(m => m.Provider).Returns(data.Provider);
            mockSet.As<IQueryable<Account>>().Setup(m => m.Expression).Returns(data.Expression);
            mockSet.As<IQueryable<Account>>().Setup(m => m.ElementType).Returns(data.ElementType);
            mockSet.As<IQueryable<Account>>().Setup(m => m.GetEnumerator()).Returns(data.GetEnumerator());

            var statusData = GetStatuses();
            var mockStatuses = new Mock<DbSet<Status>>();

            mockStatuses.As<IQueryable<Status>>().Setup(m => m.Provider).Returns(statusData.Provider);
            mockStatuses.As<IQueryable<Status>>().Setup(m => m.Expression).Returns(statusData.Expression);
            mockStatuses.As<IQueryable<Status>>().Setup(m => m.ElementType).Returns(statusData.ElementType);
            mockStatuses.As<IQueryable<Status>>().Setup(m => m.GetEnumerator()).Returns(statusData.GetEnumerator());

            dbMockContext = new Mock<IAccountBalanceContext>();
            dbMockContext.Setup(m => m.Account).Returns(mockSet.Object);
            dbMockContext.Setup(m => m.Status).Returns(mockStatuses.Object);
        }

        [Fact]
        public void AccountServiceShouldReturnValidResult()
        {
            // Arrange
            var bs = new AccountService(dbMockContext.Object);

            //Act
            var result = bs.GetAccountBalance("test");

            // Assert
            // Correct number of payments
            var paymentCount = result.Payments.Count;
            Assert.Equal(2, paymentCount);
            // Correct account name
            Assert.Equal("test", result.AccountName);
            // Correct total
            var total = result.Payments.Sum(p => p.Amount);
            Assert.Equal(0, total);
            // Correct order of payments
            var payment1Date = result.Payments[0].CreatedDateTime;
            var payment2Date = result.Payments[1].CreatedDateTime;
            Assert.True(payment1Date > payment2Date);
        }

        private IQueryable<Status> GetStatuses()
        {
            var statuses = new List<Status>
            {
                new Status { Id = 0, Description = "Open" },
                new Status { Id = 1, Description = "Closed" }
            }.AsQueryable();
            return statuses;
        }

        private IQueryable<Account> GetTestAccount()
        {
            var account = new Account
            {
                AccountName = "test",
                Status = 0,
                Comment = "Opened by test",
                CreatedDateTime = DateTime.Now,
                LastModifiedDateTime = DateTime.Now,                
                Id = 1
            };

            var payment1 = new Payment
            {
                Id = 0,
                Account = account,
                AccountId = 1,
                Amount = 25,
                CreatedDateTime = DateTime.Now.AddDays(-1)
            };

            var payment2 = new Payment
            {
                Id = 1,
                Account = account,
                AccountId = 1,
                Amount = -25,
                CreatedDateTime = DateTime.Now
            };

            account.Payment.Add(payment1);
            account.Payment.Add(payment2);

            var list = new List<Account> { account };
            return list.AsQueryable();
        }
    }
}
