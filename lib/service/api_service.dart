import 'dart:convert';
import 'package:chapainawabganjcity/models/about.dart';
import 'package:chapainawabganjcity/models/category.dart';
import 'package:chapainawabganjcity/models/data.dart';
import 'package:chapainawabganjcity/models/news.dart';
import 'package:chapainawabganjcity/models/news_category.dart';
import 'package:chapainawabganjcity/models/slider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Function to fetch categories from the API and cache them
  Future<List<Category>> fetchCategories() async {
    const String url = 'https://cnis.smartbizz.xyz/api/category';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Category> categories = data.map((json) => Category.fromJson(json)).toList();
        // Cache the categories data
        await cacheData('categories', response.body);
        return categories;
      } else {
        // Try fetching from cache if the network request fails
        return await getCachedCategories();
      }
    } catch (e) {
      // If an error occurs, fetch from cache
      return await getCachedCategories();
    }
  }

  // Fetch cached categories from SharedPreferences
  Future<List<Category>> getCachedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedCategories = prefs.getString('categories');
    if (cachedCategories != null) {
      List<dynamic> data = json.decode(cachedCategories);
      return data.map((json) => Category.fromJson(json)).toList();
    }
    return [];
  }

  // Cache the data in SharedPreferences
  Future<void> cacheData(String key, String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
  }

  // Function to fetch slider images and cache them
  Future<List<Slider>> fetchSliderImages() async {
    const String url = 'https://cnis.smartbizz.xyz/api/slider';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Slider> sliderImages = data.map((json) => Slider.fromJson(json)).toList();

        // Cache the slider images
        await cacheData('slider_images', response.body);
        return sliderImages;
      } else {
        return await getCachedSliderImages();
      }
    } catch (e) {
      return await getCachedSliderImages();
    }
  }

  // Fetch cached slider images from SharedPreferences
  Future<List<Slider>> getCachedSliderImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedSlider = prefs.getString('slider_images');
    if (cachedSlider != null) {
      List<dynamic> data = json.decode(cachedSlider);
      return data.map((json) => Slider.fromJson(json)).toList();
    }
    return [];
  }

  // Function to fetch About info and cache it
  Future<About> fetchAbout() async {
    const String url = 'https://cnis.smartbizz.xyz/api/settings_info';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        About about = About.fromJson(data);

        // Cache the About info
        await cacheData('about_info', response.body);
        return about;
      } else {
        return await getCachedAbout();
      }
    } catch (e) {
      return await getCachedAbout();
    }
  }

  // Fetch cached About info from SharedPreferences
  Future<About> getCachedAbout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedAbout = prefs.getString('about_info');
    if (cachedAbout != null) {
      Map<String, dynamic> data = json.decode(cachedAbout);
      return About.fromJson(data);
    }
    return About.fromJson({
      "name": "CNIS",
      "logo": "images/brand/dElPp7K01zy2AGag5mM8qF2pGrC01vERWDgXjjee.jpg",
      "phone": "01756560000",
      "email": "toufiq.bd77@gmail.com",
      "address": "02, Club super market, Chapainawabganj",
      "facebook": "https://www.facebook.com/share/1BotfR4fL3/",
      "linkdin": "https://www.facebook.com/",
      "instagram": "https://www.facebook.com/",
      "twitter": "https://www.facebook.com/"
    }); // Return a default object if no data is cached
  }

  // Function to fetch doctors based on category and cache them
  Future<List<Data>> fetchData(String index) async {
    String url = 'https://cnis.smartbizz.xyz/api/info_by_category/$index';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Data> doctorList = data.map((e) => Data.fromJson(e)).toList();

        // Cache the doctor list
        await cacheData(index, response.body);
        return doctorList;
      } else {
        return await getCachedData(index);
      }
    } catch (e) {
      return await getCachedData(index);
    }
  }

  Future<List<NewsCategory>> fetchNewsCategories() async {
    String url = 'https://cnis.smartbizz.xyz/api/news_category';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<NewsCategory> newsCategories = data.map((e) => NewsCategory.fromJson(e)).toList();
        return newsCategories;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<List<News>> fetchNewsByCategories(String categoryID) async {
    String url = 'https://cnis.smartbizz.xyz/api/news_by_category/$categoryID';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<News> news = data.map((e) => News.fromJson(e)).toList();
        return news;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<List<News>> fetchAllNews() async {
    String url = 'https://cnis.smartbizz.xyz/api/news';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<News> news = data.map((e) => News.fromJson(e)).toList();
        return news;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  

  // Fetch cached doctor list from SharedPreferences
  Future<List<Data>> getCachedData(String index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedDoctors = prefs.getString(index);
    if (cachedDoctors != null) {
      List<dynamic> data = json.decode(cachedDoctors);
      return data.map((e) => Data.fromJson(e)).toList();
    }
    return [];
  }
}
