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
        public JsonResult EditHopDong_DichVu([FromBody] List<HopDong_DichVu> listHopDong_DichVuObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removeHopDong_DichVu(listHopDong_DichVuObject[0].IdHopDong);
            List<HopDong_DichVu> listCTHD = new List<HopDong_DichVu>();
            for (int i = 0; i < listHopDong_DichVuObject.Count; i++)
            {
                HopDong_DichVu a = context.addHopDong_DichVu(listHopDong_DichVuObject[i].IdHopDong,listHopDong_DichVuObject[i].IdDichVu, listHopDong_DichVuObject[i].DonGia);
                //listCTHD.Append(a);
                listCTHD.Add(a);
            }
            return Json(listCTHD);

            //BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            //HopDong_DichVu a = context.AddOrUpdateHopDong_DichVu(hopdongDichVuObject.IdHopDong, hopdongDichVuObject.IdDichVu, hopdongDichVuObject.DonGia);
            //return Json(a);
        }


        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }
    }
}
