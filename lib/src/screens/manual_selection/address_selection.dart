import "dart:convert";
import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:http/http.dart" as http;
import "package:mumin/src/core/utils/encode_decode.dart";

import "cubit/manual_location_selection_cubit.dart";
import "pages/administrator_selection.dart";
import "pages/city_selection.dart";
import "pages/countries_selection.dart";

class AddressSelection extends StatefulWidget {
  const AddressSelection({super.key});

  @override
  State<AddressSelection> createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  @override
  void initState() {
    downloadLocationResources();
    super.initState();
  }

  Future<void> downloadLocationResources() async {
    context.read<ManualLocationSelectionCubit>().changeData(
          isLoading: true,
          isError: false,
          isSuccess: false,
        );
    try {
      final response = await http.get(
        Uri.parse(
            "https://quran-backend-delta.vercel.app/locations/compressed/worldcities.json.txt"),
      );

      if (response.statusCode == 200) {
        log("Location data downloaded successfully");
        Map locationResources = jsonDecode(decodeBZip2String(response.body));
        context.read<ManualLocationSelectionCubit>().changeData(
              locationData: locationResources,
              isLoading: false,
              isError: false,
              isSuccess: true,
            );
      } else {
        context.read<ManualLocationSelectionCubit>().changeData(
              isLoading: false,
              isError: true,
              isSuccess: false,
            );
      }
    } catch (e) {
      context.read<ManualLocationSelectionCubit>().changeData(
            isLoading: false,
            isError: true,
            isSuccess: false,
          );
    }
  }

  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ManualLocationSelectionCubit,
          ManualLocationSelectionState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LinearProgressIndicator(
                    value: state.downloadProgress,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Downloading Cities information",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          } else if (state.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Please check for internet connection"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: downloadLocationResources,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (state.isSuccess) {
            return PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                CountriesSelection(pageController: pageController),
                AdministratorSelection(pageController: pageController),
                CitySelection(
                  pageController: pageController,
                ),
              ],
              onPageChanged: (index) {
                context.read<ManualLocationSelectionCubit>().changeData(
                      country: state.locationData!.keys.elementAt(index),
                    );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
