using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Common.DataTransferObjects;
using Common.Interfaces;
using Data;
using Microsoft.EntityFrameworkCore;

namespace BusinessServicesLayer
{
    public class AccountService : IAccountService
    {
        private readonly IAccountBalanceContext db;

        public AccountService(IAccountBalanceContext db)
        {
            this.db = db;
        }

        public AccountBalanceDTO GetAccountBalance(string accountName)
        {
            var account = db.Account.Include(a => a.Payment).FirstOrDefault(a => a.AccountName == accountName);

            if (account == null)
            {
                throw new Exception("Account not found");
            }

            var accountDto = new AccountBalanceDTO()
            {
                AccountName = account.AccountName,
                AccountId = account.Id,
                AccountStatus = db.Status.FirstOrDefault(s => s.Id == account.Status).Description,
                AccountBalance = account.Payment.Sum(p => p.Amount)
            };

            foreach (var payment in account.Payment.OrderByDescending(p => p.CreatedDateTime))
            {
                accountDto.Payments.Add(new PaymentDTO
                {
                    Amount = payment.Amount,
                    CreatedDateTime = payment.CreatedDateTime
                });
            }

            return accountDto;
        }
    }
}
