﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using BatDongSanAPI.Models;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using System.IO;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BatDongSanAPI.Controllers
{
    public class CanHoController : Controller
    {
        private readonly IHostingEnvironment _appEnviroment; 

        public CanHoController(IHostingEnvironment appEnviroment) {
            _appEnviroment = appEnviroment;
        }

        [HttpPost("/CanHo/Upload_Image")]
        public JsonResult Upload_Image(IFormFile file) {
            string path_Root = _appEnviroment.WebRootPath;
            string path_to_Images = path_Root + "\\Image" + file.FileName;
            using (var stream = new FileStream(path_to_Images, FileMode.Create))
            {
                file.CopyToAsync(stream);
            }
            return Json("1");

        }

        [HttpGet("/CanHo/Image/{imgName}")]
        public IActionResult Get(string imgName)
        {
            Byte[] b = System.IO.File.ReadAllBytes(@"../BatDongSanAPI/Image/" + imgName);   // You can use your own method over here.         
            return File(b, "image/jpeg");
        }

        [HttpGet("/CanHo/GetListCanHo")]
        // GET: /<controller>/
        public JsonResult GetListCanHo()
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            List<CanHo> listCanHo = context.GetListCanHo();
            return Json(listCanHo);
        }

        [HttpPost("/CanHo/RemoveListCanHo")]
        public JsonResult RemoveListCanHo([FromHeader(Name = "IdCanHo")] string IdCanHo)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            context.removeCanHo(IdCanHo);
            return Json(IdCanHo);
        }


        [HttpPost("/CanHo/EditCanHo")]
        public JsonResult EditCanHo([FromBody]CanHo canHoObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            CanHo a = context.updateCanHo(canHoObject.IdCanHo, canHoObject.DonGia, canHoObject.DienTich, canHoObject.DiaChi, canHoObject.TieuDe, canHoObject.MoTa, canHoObject.AnhCanHo, canHoObject.NgayTao);
            return Json(a);
        }

        [HttpPost("/CanHo/AddCanHo")]
        public JsonResult AddCanHo([FromBody]CanHo canHoObject)
        {
            BatDongSanStoreContext context = HttpContext.RequestServices.GetService(typeof(BatDongSanStoreContext)) as BatDongSanStoreContext;
            CanHo canHoCopy = context.addCanHo(canHoObject.DonGia, canHoObject.DienTich, canHoObject.DiaChi, canHoObject.TieuDe, canHoObject. MoTa, canHoObject.AnhCanHo, canHoObject.NgayTao);
            return Json(canHoCopy);
        }
    }
}
