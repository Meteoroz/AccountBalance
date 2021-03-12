using Common.DataTransferObjects;
using System;
using System.Collections.Generic;
using System.Text;

namespace Common.Interfaces
{
    public interface IAccountService
    {
        public AccountBalanceDTO GetAccountBalance(string accountName);
    }
}
