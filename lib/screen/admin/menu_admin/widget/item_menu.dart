import 'package:flutter/material.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/util/convert.dart';

class ItemMenuCustom extends StatelessWidget {
  const ItemMenuCustom({super.key, required this.menu});
  final Menu menu;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                height: 50,
                width: 50,
                child: menu.image != null && menu.image != "null"
                    ? Image.network(
                        menu.image!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.error,
                          color: Colors.grey,
                          size: 30,
                        ),
                      )
                    : Image.network(
                        "Null",
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.error,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.itemName!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    tienviet(menu.price!),
                    style: const TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart,
                  color: Colors.orangeAccent),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
    ;
  }
}
