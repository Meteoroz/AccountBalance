using Common.DataTransferObjects;
using Common.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AccountBalance.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        private readonly IAccountService _accountService;
        private readonly ILogger<AccountController> _logger;

        public AccountController(ILogger<AccountController> logger, IAccountService accountService)
        {
            this._accountService = accountService;
            this._logger = logger;
        }

        [HttpGet]
        [Route("{accountName}")]
        public ActionResult Get(string accountName)
        {
            try
            {
                var result = _accountService.GetAccountBalance(accountName);
                return new JsonResult(result);
            }
            catch (Exception ex)
            {
                _logger.LogError($"{ex.Message} {accountName}");
                return NotFound(ex.Message);
            }
        }
    }
}
