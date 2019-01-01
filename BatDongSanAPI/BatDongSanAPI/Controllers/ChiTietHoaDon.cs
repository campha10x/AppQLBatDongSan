using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;

namespace BatDongSanAPI.Controllers
{
    public class ChiTietHoaDonController : Controller
    {
        [HttpGet]
        public JsonResult GetListChiTietHoaDon()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<ChiTietHoaDon> listCTHD = context.GetListChiTietHoaDon();
            return Json(listCTHD);
        }


        //[HttpPost("/ChiTietHoaDon/AddListChiTietHoaDon")]
        //public JsonResult AddListChiTietHoaDon([FromBody] List<ChiTietHoaDon> listChiTietHDObject)
        //{
        //    BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
        //    List<ChiTietHoaDon> listCTHD = new List<ChiTietHoaDon>();
        //    for (int i = 0; i < listChiTietHDObject.Count; i++)
        //    {
        //        ChiTietHoaDon a = context.addChiTietHoaDon(listChiTietHDObject[i].Id_HoaDon, listChiTietHDObject[i].TenDichVu, listChiTietHDObject[i].SoCu, listChiTietHDObject[i].SoMoi, listChiTietHDObject[i].DonGia);
        //        listCTHD.Append(a);
        //    }
        //    return Json(listCTHD);
        //}

        [HttpPost("/ChiTietHoaDon/AddOrEditListChiTietHoaDon")]
        public JsonResult EditListChiTietHoaDon([FromBody] List<ChiTietHoaDon> listChiTietHDObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removeChiTietHoaDon(listChiTietHDObject[0].Id_HoaDon);
            List<ChiTietHoaDon> listCTHD = new List<ChiTietHoaDon>();
            for (int i = 0; i < listChiTietHDObject.Count; i++)
            {
                ChiTietHoaDon a = context.addChiTietHoaDon(listChiTietHDObject[i].Id_HoaDon, listChiTietHDObject[i].TenDichVu, listChiTietHDObject[i].SoCu, listChiTietHDObject[i].SoMoi, listChiTietHDObject[i].DonGia);
                //listCTHD.Append(a);
                listCTHD.Add(a);
            }
            return Json(listCTHD);
        }

    }
}
