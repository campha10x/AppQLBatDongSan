using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class HopDong_DichVuController : Controller
    {


        [HttpGet("/HopDong_DichVu/GetListHopDong_DichVu")]
        // GET: /<controller>/
        public JsonResult GetListHopDong()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<HopDong_DichVu> listHopDong = context.GetListHopDong_DichVu();
            return Json(listHopDong);
        }

        [HttpPost("/HopDong_DichVu/AddOrUpdateHopDong_DichVu")]
        public JsonResult EditHopDong_DichVu([FromHeader(Name = "IdHopDong")] string IdHopDong, [FromHeader(Name = "IdDichVu")] string IdDichVu, [FromHeader(Name = "DonGia")] string DonGia)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            HopDong_DichVu a = context.AddOrUpdateHopDong_DichVu(IdHopDong,IdDichVu,DonGia);
            return Json(a);
        }


        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }
    }
}
