using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class CanHo_DichVuController : Controller
    {

        [HttpPost("/CanHo_DichVu/AddOrUpDateListCanHo_DichVu")]
        public JsonResult AddOrUpDateListCanHo_DichVu([FromHeader(Name = "IdDichVu")] string IdDichVu, [FromHeader(Name = "IdCanHo")] string IdCanHo)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            CanHo_DichVu a = context.AddOrUpDateListCanHo_DichVu(IdDichVu, IdCanHo);
            return Json(a);
        }


         [HttpGet("/CanHo_DichVu/GetListCanHo_DichVu")]
        // GET: /<controller>/
        public JsonResult GetListCanHo()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<CanHo_DichVu> listCanHo = context.GetListCanHo_DichVu();
            return Json(listCanHo);
        }

        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }
    }
}
