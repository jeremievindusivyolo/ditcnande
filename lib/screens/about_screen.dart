// about_screen.dart
// A simple About page with a PayPal donation button.

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _paypalUrl = 'https://www.paypal.com/ncp/payment/DW66UZM7EE5SC';

  Future<void> _launchPayPal(BuildContext context) async {
    final uri = Uri.parse(_paypalUrl);
    try{
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open PayPal')),
          );
        }
      }
    }catch(e){
      print(e);
    }

  }
  Future<void> openWhatsApp(String number, {String? message}) async {
    final digits   = number.replaceAll(RegExp(r'[^0-9]'), ''); // clean
    final encoded  = message != null ? Uri.encodeComponent(message) : '';
    final uri      = Uri.parse(
        'https://wa.me/$digits${encoded.isNotEmpty ? '?text=$encoded' : ''}');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('À propos de l\'application', style: Theme.of(context).textTheme.titleMedium)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dictionnaire Kinande–Français',
              style: textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Text(
              "Cette application-dictionnaire est un projet communautaire. Les mots sont ajoutés progressivement, car nous sommes une petite équipe de bénévoles. Merci de votre patience !",
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _launchPayPal(context),
                icon: const Icon(Icons.favorite),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                label: const Text('Soutenir le projet'),
              ),
            ),const SizedBox(height: 12),
            Text(
              "Votre don aide à couvrir l\'hébergement, l\'ajout de nouveaux mots et le développement de futures fonctionnalités. Merci !",
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text('Développeur :', style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Jeremie Mumbere Lwatumba', style: textTheme.bodyLarge),
            Text('jeremievindu@gmail.com', style: textTheme.bodyMedium),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text('Contacter sur :', style: textTheme.titleSmall),
                ),
                GestureDetector(
                  onTap: () => openWhatsApp('+243999570541', message: 'kúti'),
                  child: SvgPicture.asset(
                    'assets/imgs/Digital_Inline_Dark_Green.svg',
                    width: MediaQuery.of(context).size.width * 0.30,        // keep the icon crisp
                    semanticsLabel: 'WhatsApp logo',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Pourquoi cette application ?', style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              "Malgré la richesse de la langue nande, de nombreux enfants dans les familles Banande grandissent aujourd\'hui sans la parler. J'ai créé cette application pour préserver notre patrimoine linguistique et offrir un outil simple et moderne pour (re)découvrir le kinande. Chaque mot ajouté est une pierre de plus pour que notre culture continue de vivre et d\'inspirer le monde.",
              style: textTheme.bodyLarge,
            ),
            SizedBox(height: 48)


          ],
        ),
      ),
    );
  }
}
